Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:60899 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758705Ab1ELVRv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 May 2011 17:17:51 -0400
Received: by ewy4 with SMTP id 4so731182ewy.5
        for <linux-wireless@vger.kernel.org>; Thu, 12 May 2011 14:17:26 -0700 (PDT)
Subject: Re: [PATCH] wl12xx: Unmask beacons includes IE 'HT information'
 change
From: Luciano Coelho <coelho@ti.com>
To: Shahar Levi <shahar_levi@ti.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1305101662-12247-1-git-send-email-shahar_levi@ti.com>
References: <1305101662-12247-1-git-send-email-shahar_levi@ti.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 00:17:22 +0300
Message-ID: <1305235042.12586.1057.camel@cumari> (sfid-20110512_231755_212851_B11261A9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2011-05-11 at 11:14 +0300, Shahar Levi wrote:
> All beacons includes changes in IE 'HT information' (IE 61) will
> be pass to the MAC80211 layer in order to be update with HT
> run time setting.
> Enable that via beacon filter mechanism.
> 
> Signed-off-by: Shahar Levi <shahar_levi@ti.com>
> ---

Applied.  I modified the commit subject and the commit message so that
it's a bit clearer.

Thanks!

-- 
Cheers,
Luca.

