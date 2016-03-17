//
//  SCProtocolView.m
//  SuperCourse
//
//  Created by 刘芮东 on 16/3/17.
//  Copyright © 2016年 Develop. All rights reserved.
//

#import "SCProtocolView.h"
@interface SCProtocolView()

@property (nonatomic, strong)UIButton   *backImageBtn;
@property (nonatomic, strong) IBOutlet UIView *topView;
@property (nonatomic, strong) IBOutlet UILabel *topLabel;
@property (nonatomic, strong) IBOutlet UILabel *lesIntroductionLabel;
@property (nonatomic, strong) IBOutlet UILabel *memberLabel;
@property (nonatomic, strong) IBOutlet UILabel *thankmemberLabel;
@property (nonatomic, strong) UITextView *protocolTextView;

@end

@implementation SCProtocolView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self){
        self.backgroundColor=[UIColor whiteColor];
        self.frame = frame;
        self.backImageBtn.frame=CGRectMake(self.width/2-350*WidthScale, 375+HeightScale*500, 700*WidthScale, 100*HeightScale);
        self.protocolTextView.frame=CGRectMake(40, self.height*0.12+40, self.width-80, 375+HeightScale*500-self.height*0.12-80);
        [self addSubview:self.topView];
        [self addSubview:self.topLabel];
        
        
        [self addSubview:self.backImageBtn];
        [self addSubview:self.protocolTextView];
        
        
    }
    return self;
}

#pragma mark - getters
-(UIView *)topView{
    
    if (!_topView) {
        _topView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.width,self.height*0.12)];
        [_topView setBackgroundColor:UIBackgroundColor];
    }
    return _topView;
}

-(UILabel *)topLabel{
    
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, self.width,self.height*0.12)];
        //[_topLabel setTextColor:[UIColor blackColor]];
        [_topLabel setBackgroundColor:[UIColor clearColor]];
        [_topLabel setText:@"用户协议"];
        _topLabel.font = [UIFont systemFontOfSize:50*WidthScale];
    }
    return _topLabel;
}

-(UILabel *)lesIntroductionLabel{
    
    if (!_lesIntroductionLabel) {
        _lesIntroductionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20*WidthScale, self.height*0.172, self.width-40*WidthScale, self.height*0.528)];
        [_lesIntroductionLabel setTextColor:[UIColor grayColor]];
        
        [_lesIntroductionLabel setBackgroundColor:[UIColor clearColor]];
        //        _lesIntroductionLabel.layer.borderColor = UIBackgroundColor.CGColor;
        //        _lesIntroductionLabel.layer.borderWidth = 2;
        _lesIntroductionLabel.text = [NSString stringWithFormat:@"          这是一款神奇的视频课程播放器。它支持视频超级链接。您可以像浏览网页一样观看视频课程，随时点击跳转到您关注的内容。它特别适合您自学视频课程时使用。预先组织好的知识链接，可以为您节省大量的查找资料的时间。"];
        _lesIntroductionLabel.font = [UIFont systemFontOfSize:55*WidthScale];
        _lesIntroductionLabel.lineBreakMode = UILineBreakModeWordWrap;
        _lesIntroductionLabel.numberOfLines = 0;
    }
    
    return _lesIntroductionLabel;
}

-(UILabel *)memberLabel{
    
    if (!_memberLabel) {
        _memberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height*0.7, self.width-20*WidthScale, self.height*0.15)];
        [_memberLabel setTextColor:[UIColor grayColor]];
        
        [_memberLabel setBackgroundColor:[UIColor clearColor]];
        //        _memberLabel.layer.borderColor = UIBackgroundColor.CGColor;
        //        _memberLabel.layer.borderWidth = 2;
        _memberLabel.text = [NSString stringWithFormat:@"制作成员：孙锐、刘芮东、李昶辰                             "];
        _memberLabel.font = [UIFont systemFontOfSize:35*WidthScale];
        _memberLabel.lineBreakMode = UILineBreakModeWordWrap;
        _memberLabel.textAlignment = UITextAlignmentRight;
        _memberLabel.numberOfLines = 0;
    }
    
    return _memberLabel;
    
}
-(UILabel *)thankmemberLabel{
    
    if (!_thankmemberLabel) {
        _thankmemberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height*0.85, self.width-20*WidthScale, self.height*0.15)];
        [_thankmemberLabel setTextColor:[UIColor grayColor]];
        
        [_thankmemberLabel setBackgroundColor:[UIColor clearColor]];
        //        _thankmemberLabel.layer.borderColor = UIBackgroundColor.CGColor;
        //        _thankmemberLabel.layer.borderWidth = 2;
        _thankmemberLabel.text = [NSString stringWithFormat:@"特别感谢：金钟、孙中原、李斌、刘祥丰、肖晓青                             "];
        _thankmemberLabel.font = [UIFont systemFontOfSize:35*WidthScale];
        _thankmemberLabel.lineBreakMode = UILineBreakModeWordWrap;
        _thankmemberLabel.textAlignment = UITextAlignmentRight;
        _thankmemberLabel.numberOfLines = 0;
    }
    
    return _thankmemberLabel;
    
}
-(UIButton *)backImageBtn{
    if(!_backImageBtn){
        _backImageBtn=[[UIButton alloc]init];
        _backImageBtn.backgroundColor=UIThemeColor;
        //        NSString *stu_id = ApplicationDelegate.userSession;
        //        NSString *stu_pwd = ApplicationDelegate.userPsw;
        
        [_backImageBtn setTitle:@" 确       认 " forState:UIControlStateNormal];
        [_backImageBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //[_exitBtn addTarget:self action:@selector(Share) forControlEvents:UIControlEventTouchUpInside];
        
        
        [_backImageBtn setFont:[UIFont systemFontOfSize:45*WidthScale]];
        [_backImageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _backImageBtn.layer.masksToBounds = YES;
        _backImageBtn.layer.cornerRadius = 36;
        //_exitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
    }
    
    return _backImageBtn;
}
-(void)backBtnClick{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"clearProtocol" object:nil];
}
-(UITextView *)protocolTextView{
    if(!_protocolTextView){
        _protocolTextView=[[UITextView alloc]init];
        _protocolTextView.text=@"服务协议\n本协议是您与超课APP（简称“本客户端”）所有者天津财经大学之间就本客户端服务等相关事宜所订立的契约，请您仔细阅读本注册协议，您点击“注册”按钮后，本协议即构成对双方有约束力的法律文件。\n\n第1条本客户端服务条款的确认和接纳\n\n1.1. 本客户端的各项电子服务的所有权和运作权归超课APP所有。用户同意所有注册协议条款并完成注册程序，才能成为本客户端的正式用户。用户确认：本协议条款是处理双方权利义务的契约，始终有效，法律另有强制性规定或双方另有特别约定的，依其规定。\n\n1.2. 用户点击同意本协议的，即视为用户确认自己具有享受本客户端服务、记录等相应的权利能力和行为能力，能够独立承担法律责任。\n\n1.3. 超课保留在中华人民共和国大陆地区法施行之法律允许的范围内独自决定拒绝服务、关闭用户账户、清除或编辑内容或解除医生与用户关系的权利。\n\n1.4. 用户使用本客户端提供的服务时，应同时接受适用于本客户端特定服务、活动等的准则、条款和协议（以下简称“特殊条款”）；如果本协议之约定与特殊条款不一致的，以特殊条款为准。\n\n第2条本客户端服务\n\n2.1. 超课APP通过互联网依法为用户提供互联网信息等服务，用户在完全同意本协议及本客户端规定的情况下，方有权使用本客户端的相关服务。\n\n2.2. 用户必须自行准备如下设备和承担如下开支：\n\n（1） 上网设备，包括并不限于电脑或者其他上网终端、调制解调器及其他必备的上网装置；\n\n（2） 上网开支，包括并不限于网络接入费、上网设备租用费、手机流量费等。\n\n第3条用户信息\n\n3.1. 用户应自行诚信向本客户端提供注册资料，用户同意其提供的注册资料真实、准确、完整、合法有效，用户注册资料如有变动的，应及时更新其注册资料。如果用户提供的注册资料不合法、不真实、不准确、不详尽的，用户需承担因此引起的相应责任及后果，并且超课APP保留终止用户使用本客户端各项服务的权利。\n\n3.2. 用户在本客户端进行注册、浏览、购买、评价等活动时，涉及用户真实姓名/名称、通信地址、联系电话、电子邮箱等隐私信息的，本站将予以严格保密，除非得到用户的授权、为履行强制性法律义务（如政府部门指令）或法律另有规定，本站不会向外界披露用户隐私信息。\n\n3.3. 用户注册成功后，将产生用户名和密码等账户信息，您可以根据本客户端规定改变您的密码。用户应谨慎合理的保存、使用其用户名和密码。用户若发现任何非法使用用户账号或存在安全漏洞的情况，请立即通知本客户端并向公安机关报案。\n\n3.4. 用户同意，超课APP拥有通过邮件、短信、电话、网站通知或声明等形式，向在本客户端注册的用户发送活动等告知信息的权利。\n\n3.5. 用户不得将在本站注册获得的账户借给他人使用，否则用户应承担由此产生的全部责任，并与实际使用人承担连带责任。\n\n3.6. 用户同意，超课APP有权使用用户的注册信息、用户名、密码等信息，登陆进入用户的注册账户，进行证据保全，包括但不限于公证、见证等。\n\n第4条用户依法言行义务\n\n本协议依据国家相关法律法规规章制定，用户同意严格遵守以下义务：\n\n（1）不得传输或发表：煽动抗拒、破坏宪法和法律、行政法规实施的言论，煽动颠覆国家政权，推翻社会主义制度的言论，煽动分裂国家、破坏国家统一的的言论，煽动民族仇恨、民族歧视、破坏民族团结的言论；\n\n（2） 从中国大陆向境外传输资料信息时必须符合中国有关法规；\n\n（3） 不得利用本客户端从事洗钱、窃取商业秘密、窃取个人信息等违法犯罪活动；\n\n（4）不得干扰本客户端的正常运转，不得侵入本客户端及国家计算机信息系统；\n\n（5） 不得传输或发表任何违法犯罪的、骚扰性的、中伤他人的、辱骂性的、恐吓性的、伤害性的、庸俗的、淫秽的、不文明的等信息资料；\n\n（6） 不得传输或发表损害国家社会公共利益和涉及国家安全的信息资料或言论；\n\n（7） 不得教唆他人从事本条所禁止的行为；\n\n（8） 不得利用在本客户端注册的账户进行牟利性经营活动；\n\n（9）不得发布任何侵犯他人著作权、商标权等知识产权或合法权利的内容；用户应关注并遵守本客户端不时公布或修改的各类合法规则规定。本客户端保有删除各类不符合法律政策或不真实的信息内容而无须通知用户的权利。若用户未遵守以上规定的，本客户端有权作出独立判断并采取暂停或关闭用户帐号等措施。用户须对自己在网上的言论和行为承担法律责任。\n\n第5条所有权及知识产权条款\n\n5.1. 用户一旦接受本协议，即表明该用户主动将其在任何时间段在本客户端发表的任何形式的信息内容（包括但不限于咨询、记录、各类话题文章等信息内容）的财产性权利等任何可转让的权利，如著作权财产权（包括并不限于：复制权、发行权、出租权、展览权、表演权、放映权、广播权、信息网络传播权、摄制权、改编权、翻译权、汇编权以及应当由著作权人享有的其他可转让权利），全部独家且不可撤销地无偿转让给超课APP所有，用户同意超课APP有权就任何主体侵权而单独提起诉讼。\n\n5.2. 本协议已经构成《中华人民共和国著作权法》第二十五条（条文序号依照2011年版著作权法确定）及相关法律规定的著作财产权等权利转让书面协议，其效力及于用户在本客户端上发布的任何受著作权法保护的作品内容，无论该等内容形成于本协议订立前还是本协议订立后。\n\n5.3. 用户同意并已充分了解本协议的条款，承诺不将已发表于本客户端的信息，以任何形式发布或授权其它主体以任何方式使用（包括但限于在各类网站、媒体上使用）。\n\n5.4. 超课APP是本客户端的制作者，拥有此客户端内容及资源的著作权等合法权利，受国家法律保护，有权不时地对本协议及本客户端的内容进行修改，并在本客户端张贴，无须另行通知用户。在法律允许的最大限度范围内，超课APP对本协议及本客户端内容拥有解释权。\n\n5.5. 除法律另有强制性规定外，未经超课APP明确的特别书面许可，任何单位或个人不得以任何方式非法地全部或部分复制、转载、引用、链接、抓取或以其他方式使用本客户端的信息内容，否则，超课APP有权追究其法律责任。\n\n5.6. 本客户端所刊登的资料信息（诸如文字、图表、标识、按钮图标、图像、声音文件片段、数字下载、数据编辑和软件），均是超课APP或其内容提供者的财产，受中国和国际版权法的保护。本客户端上所有内容的汇编是超课APP的排他财产，受中国和国际版权法的保护。本客户端上所有软件都是超课APP的财产，受中国和国际版权法的保护。\n\n第6条责任限制及不承诺担保\n\n6.1. 除非另有明确的书面说明，本客户端及其所包含的或以其它方式通过本客户端提供给您的全部信息、内容、材料、产品（包括软件）和服务，均是在“按现状”和“按现有”的基础上提供的。除非另有明确的书面说明，超课APP不对本客户端的运营及其包含在本客户端上的信息、内容、材料、产品（包括软件）或服务作任何形式的、明示或默示的声明或担保（根据中华人民共和国法律另有规定的以外）。\n\n6.2. 一超课APP不担保本客户端所包含的或以其它方式通过本客户端提供给您的全部信息、内容、材料、产品（包括软件）和服务、其服务器或从本客户端发出的电子信件、信息没有病毒或其他有害成分。如因不可抗力或其它本站无法控制的原因使本客户端销售系统崩溃或无法正常使用导致网上交易无法完成或丢失有关的信息、记录等，超课APP会合理地尽力协助处理善后事宜。\n\n6.3. 本客户端所承载的内容（文、图、视频、音频）均为传播有益健康资讯目的，不对其真实性、科学性、严肃性做任何形式保证。\n\n•\t超课APP需保证提供安全、稳定的服务平台，保证服务的顺利进行。\n\n•\t如服务在进行过程中由于本客户端平台性能不稳定等系统原因导致服务不能完成的，将由本客户端客服为您安排重新咨询服务。\n\n•\t用户必须在注册时，详细阅读本客户端使用说明信息，并严格按要求操作。在个人信息部分必须提供真实的用户信息。\n\n•\t一旦发现用户提供的个人信息中有虚假，超课APP有权立即终止向用户提供的所有服务，并冻结用户的帐户，有权要求用户赔偿因提供虚假信息给超课APP造成的损失。\n\n•\t咨询均只限于根据用户的主观描述\n\n7.2. 咨询服务中超课APP与用户双方的权利及义务\n\n•\t超课APP有义务在现有技术上维护平台服务的正常进行，并努力提升技术及改进技术，使网站服务更好进行。\n\n•\t对于用户在本客户端预定服务中的不当行为或其它任何超课APP认为应当终止服务的情况，天津财经大学有权随时作出删除相关信息、终止服务提供等处理，而无须征得用户的同意。\n\n•\t如存在下列情况：\n\n（1）用户或其它第三方通知超课APP，认为某个具体用户可能存在重大问题；\n\n（2）用户或其它第三方向超课APP告知咨询内容有违法或不当行为的，超课APP以普通非专业的知识水平标准对相关内容进行判别，可以明显认为这些内容或行为具有违法或不当性质的。\n\n•\t超课APP有义务对相关数据、所有的申请行为以及与咨询有关的其它事项进行审查。\n\n•\t超课APP有权根据不同情况选择保留或删除相关信息或继续、停止对该用户提供服务，并追究相关法律责任。\n\n•\t咨询双方因服务引起的纠纷，请超课APP给予调解的，超课APP将有权了解相关信息，并将双方提供的信息与对方沟通。因在本客户端上发生服务纠纷，引起诉讼的，用户通过司法部门或行政部门依照法定程序要求超课APP提供相关数据，超课APP应积极配合并提供有关资料。\n\n•\t超课APP有权对用户的注册数据及在线咨询的行为进行查阅，发现注册数据或咨询行为中存在任何问题或怀疑，均有权向用户发出询问及要求改正的通知或者直接作出删除等处理。\n\n•\t用户对咨询内容不满意，可以向超课APP提出投诉，超课APP有义务依据情况协调沟通，维护医生和用户关系和谐。\n\n•\t系统因下列状况无法正常运作，使用户无法使用在线咨询服务时，超课APP不承担损害赔偿责任，该状况包括但不限于：\n\n（1）超课APP在本客户端网站公告之系统停机维护期间；\n\n（2）电信设备出现故障不能进行数据传输的；\n\n（3）因台风、地震、海啸、洪水、停电、战争、恐怖袭击等不可抗力之因素，造成系统障碍不能执行业务的；\n\n（4）由于黑客攻击、电信部门技术调整或故障、银行方面的问题等原因而造成的服务中断或者延迟。\n\n第8条协议更新及用户关注义务\n\n根据国家法律法规变化及网络运营需要，超课APP有权对本协议条款不时地进行修改，修改后的协议一旦被张贴在本客户端上即生效，并代替原来的协议。用户可随时登陆查阅最新协议；用户有义务不时关注并阅读最新版的协议及客户端公告。如用户不同意更新后的协议，可以且应立即停止接受本客户端依据本协议提供的服务；如用户继续使用本客户端提供的服务，即视为同意更新后的协议。超课APP建议您在使用本客户端之前阅读本协议及本客户端的公告。如果本协议中任何一条被视为废止、无效或因任何理由不可执行，该条应视为可分的且并不影响任何其余条款的有效性和可执行性。\n\n第9条法律管辖和适用\n\n本协议的订立、执行和解释及争议的解决均应适用在中华人民共和国大陆地区适用之有效法律（但不包括其冲突法规则）。如发生本协议与适用之法律相抵触时，则这些条款将完全按法律规定重新解释，而其它有效条款继续有效。如缔约方就本协议内容或其执行发生任何争议，双方应尽力友好协商解决；协商不成时，任何一方均可向超课APP住所地有管辖权的人民法院提起诉讼。\n\n第10条其他\n\n10.1. 本客户端所有者是指在政府部门依法许可或备案的本客户端的经营主体及其关联方。\n\n10.2. 超课APP尊重用户的合法权利，本协议及本客户端上发布的各类规则、声明等其他内容，均是为了更好的、更加便利的为用户提供服务。本客户端欢迎用户和社会各界提出意见和建议，超课APP将虚心接受并适时修改本协议及本客户端的各类规则。\n\n10.3. 本协议内容中以黑体、加粗、下划线、斜体等方式显著标识的条款，请用户着重阅读。\n\n10.4. 您点击本协议上方的“注册”按钮即视为您完全接受本协议，在点击之前请您再次确认已知悉并完全理解本协议的全部内容。\n\n天津财经大学\n2016年3月\n";
        _protocolTextView.font=[UIFont systemFontOfSize:23.5];
    }
    return _protocolTextView;
}
@end
