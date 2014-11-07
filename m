Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from relay1.mentorg.com ([192.94.38.131]:32927 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435AbaKGL4j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 06:56:39 -0500
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Jes.Sorensen@redhat.com" <Jes.Sorensen@redhat.com>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging:rtl8723au: core: Fix error reported by
 checkpatch.
Date: Fri, 7 Nov 2014 11:56:35 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE950E8B8F8@EU-MBX-02.mgc.mentorg.com> (sfid-20141107_125711_127748_0B5E360C)
References: <wrfjy4rxzk5b.fsf@redhat.com>
 <1415254573-3451-1-git-send-email-sanjeev_sharma@mentor.com>
 <20141106154120.GB19605@kroah.com>
In-Reply-To: <20141106154120.GB19605@kroah.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Thursday, November 06, 2014 9:11 PM
To: Sharma, Sanjeev
Cc: Larry.Finger@lwfinger.net; Jes.Sorensen@redhat.com; devel@driverdev.osuosl.org; linux-wireless@vger.kernel.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:rtl8723au: core: Fix error reported by checkpatch.

Please specify the "error" in the subject in some way.

On Thu, Nov 06, 2014 at 11:46:13AM +0530, Sanjeev Sharma wrote:
> This is a patch to the rtw_cmd.c file that fixes following error.
> 
> ERROR: spaces required around that '>' (ctx:WxV)
> ERROR: that open brace { should be on the previous line
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_cmd.c | 83 
> +++++++++++++++-----------------
>  1 file changed, 40 insertions(+), 43 deletions(-)

This does two different things, please make it different patches.

For individual Error, is Separate patch needed. If Error has been mentioned in description. then it should be OK IMO. 

And you sent 2 patches, with no hint as to which one comes before which.
Please resend all of them, correctly numbered in a series, so that I have a chance to get the order correct when applying them.
