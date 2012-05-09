Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55503 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756028Ab2EIQdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 May 2012 12:33:20 -0400
Received: by eaaq12 with SMTP id q12so201555eaa.19
        for <linux-wireless@vger.kernel.org>; Wed, 09 May 2012 09:33:19 -0700 (PDT)
Date: Wed, 9 May 2012 18:33:04 +0200
From: Anisse Astier <anisse@astier.eu>
To: Zero Lin (=?UTF-8?B?5p6X55Ge6Z2S?=) <zero.lin@mediatek.com>
Cc: Gertjan van Wingerde <gwingerde@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [rt2x00-users] [PATCH] rt2x00:Add RT539B chipset support V2
Message-ID: <20120509183304.409ace0e@destiny.ordissimo> (sfid-20120509_183323_054609_D4203390)
In-Reply-To: <599E416D1C5C994980C45977191D726906AB2FE230@MTKMBS03.mediatek.inc>
References: <1336361682-2771-1-git-send-email-zero.lin.0203@gmail.com>
	<CAL1gcdMBj_w5qbMX=kxcW6yow7UgSfSrWjz6TrKkFZiJCtS1cg@mail.gmail.com>
	<599E416D1C5C994980C45977191D726906AB2FE230@MTKMBS03.mediatek.inc>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 7 May 2012 21:18:50 +0800, Zero Lin (林瑞青) <zero.lin@mediatek.com> wrote :

> Dear Gertjan,
> 
> I am sorry, what should I do now?
> Re-send a patch?

I think what Gertjan meant is that you should resend the first version of
you patch with the 0x539b in the correct position.

The problem with the V2 of your patch was that it was on top of your first
version, therefore not usable separately.

> 
> BR,
> Zero
> 
> -----Original Message-----
> From: Gertjan van Wingerde [mailto:gwingerde@gmail.com] 
> Sent: Monday, May 07, 2012 8:40 PM
> To: Zero Lin
> Cc: users@rt2x00.serialmonkey.com; linux-wireless@vger.kernel.org; John Linville; Zero Lin (林瑞青)
> Subject: Re: [PATCH] rt2x00:Add RT539B chipset support V2
> 
> Hi,
> 
> On Mon, May 7, 2012 at 5:34 AM, Zero Lin <zero.lin.0203@gmail.com> wrote:
> > From: "Zero.Lin" <Zero.Lin@mediatek.com>
> >
> > Signed-off-by: Zero.Lin <Zero.Lin@mediatek.com>  
> 
> I'm sorry, but you will have to do this as a complete new patch replacing your old one, not as an incremental to your initial patch.

Regards,

Anisse
