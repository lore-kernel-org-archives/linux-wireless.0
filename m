Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:40587 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab2J3C6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Oct 2012 22:58:07 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so7618560iea.19
        for <linux-wireless@vger.kernel.org>; Mon, 29 Oct 2012 19:58:05 -0700 (PDT)
Message-ID: <508F423A.4010407@lwfinger.net> (sfid-20121030_035821_576790_022C6930)
Date: Mon, 29 Oct 2012 21:58:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Cliff McDiarmid <cliffhanger@gardener.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: RTL8188SU
References: <loom.20121028T233054-8@post.gmane.org> <201210291257.02249.chunkeey@googlemail.com> <loom.20121029T182405-382@post.gmane.org> <201210292117.45399.chunkeey@googlemail.com> <loom.20121029T214630-424@post.gmane.org> <508EFA5D.8090706@lwfinger.net> <loom.20121029T234700-352@post.gmane.org>
In-Reply-To: <loom.20121029T234700-352@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/29/2012 05:59 PM, Cliff McDiarmid wrote:

> Thanks Larry I'm confusing the issue here, by not getting the no's right.  I was
> asking about the rtl8192su driver which I understand works in monitor mode.  I
> assume this driver has been 'cleaned up' and become the r8712u.  I was wondering
> if I could use an earlier version of the rtl8192su driver with the RTL8188SU and
> in doing so have the monitor mode.

To my knowledge, none of the Realtek, non-mac80211 drivers work in monitor mode; 
however, if you think they do, then you can get such drivers from realtek.com. 
Please be aware that there is a definite possibility that such drivers will not 
build on recent kernels. In addition, they are unlikely to work on 64-bit 
kernels. I keep sending patches to them, but such changes seem to not be 
implemented.

Larry


