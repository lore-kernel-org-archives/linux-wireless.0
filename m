Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:39821 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932835Ab2LHDhW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Dec 2012 22:37:22 -0500
Received: by mail-wi0-f180.google.com with SMTP id hj13so71916wib.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Dec 2012 19:37:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.02.1212080721070.8165@icf.org.ru>
References: <BD54DDEB2546894FAB0731EA7B0EDF8D07C1256F@RockMX01.rock.corp>
 <alpine.DEB.2.02.1212031842350.27546@icf.org.ru> <CAG6hwVM3GFe-v7fONDR_2wuggT+z_ZhDQN-pH7BA1gyxLZzDQQ@mail.gmail.com>
 <alpine.DEB.2.02.1212080721070.8165@icf.org.ru>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Fri, 7 Dec 2012 19:37:00 -0800
Message-ID: <CAG6hwVO8c9ypYS4S0sDUf37eJJuK_5hrgCwCNKwqGLt2BWOtYA@mail.gmail.com> (sfid-20121208_043728_923113_BEE7F1E0)
Subject: Re: help: 802.11s bad performance with 802.11n enabled
To: Georgiewskiy Yuriy <bottleman@icf.org.ru>
Cc: Chaoxing Lin <Chaoxing.Lin@ultra-3eti.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	open11s <devel@lists.open80211s.org>
Content-Type: text/plain; charset=KOI8-R
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 7, 2012 at 7:23 PM, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:
> On 2012-12-07 19:17 -0800, Thomas Pedersen wrote Georgiewskiy Yuriy:
>
> ок, i try this and report results, can you also test on 2.4 Ggz? as i
> understand ch 149 is 802.11a? or this make no sense here?

Yes I get similar results on the 2.4Ghz band, and no it shouldn't make
a difference here :)

> TP>Hi Chaoxing and Georgiewsky,
> TP>
> TP>On Mon, Dec 3, 2012 at 6:45 AM, Georgiewskiy Yuriy <bottleman@icf.org.ru> wrote:
> TP>> On 2012-12-03 14:37 -0000, Chaoxing Lin wrote linux-wireless@vger.kernel.org:
> TP>>
> TP>> CL>After a lot of experiments, here are various problems observed.
> TP>> CL>
> TP>> CL>1. The "Fail to stop Tx DMA" related issue plays a role. But not the major part. It accounts for about 3% of packet loss in my testbed.
> TP>> CL>Is anyone looking at this issue? This issue is now very easy to recreate.
> TP>>
> TP>> In my case it much more than 3%.
> TP>
> TP>With wireless-testing HEAD (671c924) I made the following observations
> TP>with 3 nodes in a mesh using ch. 149 HT20 on AR9280.
> TP>
> TP>1. ping -i0.1 does not cause aggregation to take place, and losses are 0%
> TP>2. a UDP iperf test with two nodes generating traffic shows losses
> TP>around 1%. We can observe aggregation taking place in this case.
> TP>
> TP>Can either of you guys reproduce this with the latest
> TP>wireless-testing? Also please CC devel@lists.open80211s.org on any
> TP>mesh bugs in the future.
> TP>
> TP>Thanks!
> TP>Thomas
> TP>--
> TP>To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> TP>the body of a message to majordomo@vger.kernel.org
> TP>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> TP>
>
> C уважением                       With Best Regards
> Георгиевский Юрий.                Georgiewskiy Yuriy
> +7 4872 711666                    +7 4872 711666
> факс +7 4872 711143               fax +7 4872 711143
> Компания ООО "Ай Ти Сервис"       IT Service Ltd
> http://nkoort.ru                  http://nkoort.ru
> JID: GHhost@icf.org.ru            JID: GHhost@icf.org.ru
> YG129-RIPE                        YG129-RIPE
