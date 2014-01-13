Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:35743 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751527AbaAMSTD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 13:19:03 -0500
Received: from compute3.internal (compute3.nyi.mail.srv.osa [10.202.2.43])
	by gateway1.nyi.mail.srv.osa (Postfix) with ESMTP id 0F8F620ADE
	for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 13:18:58 -0500 (EST)
Message-Id: <1389637138.15239.70208649.23172696@webmail.messagingengine.com> (sfid-20140113_191908_654061_72262548)
From: "Nikita N." <nikitan@operamail.com>
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain
In-Reply-To: <52D41306.5060106@broadcom.com>
References: <1389605447.17065.70000145.1A7719E9@webmail.messagingengine.com>
 <52D41306.5060106@broadcom.com>
Subject: Re: brcmsmac on BCM4313: frames 11n not shown in monitor mode
Date: Mon, 13 Jan 2014 10:18:58 -0800
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes Arend, I confirm, 802.11 frames transmitted at 11n bitrate.
The card looks 11n capable, as it handshakes allright from Windows with
my router set to 11n only (beacon frames contain all HT tags as normal)
But when I flip in monitor mode under Linux, only 11b/g frames are shown
(Wireshark,no filter)
Yes of course I can send you a capture, any particular frames do you
want inside?
Regards

On Mon, Jan 13, 2014, at 08:23 AM, Arend van Spriel wrote:
> On 01/13/2014 10:30 AM, Nikita N. wrote:
> > Hi All :) an issue for the maintainers of brcmsmac, or anybody who
> > knows.
> > Using module brcmsmac, when I flip my BCM4313 in monitor mode, it shows
> > allright all frames sent in 11b and 11g mode, but the *11n* ones are NOT
> > shown, maybe filtered out or not detected.
> > Is that a known bug?
> > If not, how can I set brcmsmac to show also 11n frames?
> 
> What do you mean by 11n frames? Do you mean 802.11 frames transmitted at
> a 11n bitrate? Can you share a capture?
> 
> Regards,
> Arend

-- 
http://www.fastmail.fm - Faster than the air-speed velocity of an
                          unladen european swallow

