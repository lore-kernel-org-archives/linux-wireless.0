Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65082 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751828Ab2CAMNh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 1 Mar 2012 07:13:37 -0500
Received: by iagz16 with SMTP id z16so718809iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 01 Mar 2012 04:13:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F4E903B.2030501@mlbassoc.com>
References: <4F4E903B.2030501@mlbassoc.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 1 Mar 2012 14:13:16 +0200
Message-ID: <CAK=WgbbO2fv-hp6vJ8-rhRvzGgs26kd5UGWp_vWveXb_VmpsoA@mail.gmail.com> (sfid-20120301_131339_814095_03EEEE50)
Subject: Re: Problems with wl1271
To: Gary Thomas <gary@mlbassoc.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 29, 2012 at 10:53 PM, Gary Thomas <gary@mlbassoc.com> wrote:
> If I try to scan for an access point, I get nothing:
>  # iw wlan0 scan
>  --- Nothing prints

You might be using a wrong reference clock value (see
include/linux/wl12xx.h for more info, look for 'clock').
