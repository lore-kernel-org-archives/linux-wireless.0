Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:36268 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751196AbdARDDb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Jan 2017 22:03:31 -0500
Received: by mail-ot0-f195.google.com with SMTP id 36so41107otx.3
        for <linux-wireless@vger.kernel.org>; Tue, 17 Jan 2017 19:02:29 -0800 (PST)
Subject: Re: Clarifying rtl8188ee's channel wifi changing code
To: Farhan Khan <farhan@offmail.us>, linux-wireless@vger.kernel.org
References: <20170118054001.GA88602@offmail.us>
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <1c751468-a3f8-19ff-4fc3-d426fb5cb8e0@lwfinger.net> (sfid-20170118_040336_150127_DBFC17A5)
Date: Tue, 17 Jan 2017 21:02:26 -0600
MIME-Version: 1.0
In-Reply-To: <20170118054001.GA88602@offmail.us>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/17/2017 11:40 PM, Farhan Khan wrote:
> Hi all,
>
> I am having a bit of trouble understanding the rtl8188ee source,
> specifically how its switch_channel function (rtl88e_phy_sw_chnl) works. I
> gather that this function calls rtl88ee_phy_sw_chnl_callback, which in turn
> calls _rtl88_phy_sw_chnl_step_by_step (
> https://github.com/torvalds/linux/blob/master/drivers/net/wireless/realtek/rtlwifi/rtl8188ee/phy.c#L1253
> ).
>
> This is where I get lost. Where is the 'channel' variable used, other than
> to change the TX power? I presume it has something to do with case
> CMDID_RF_WRITEREG, but I am not certain.
>
> Please explain what is going on. Thank you!

I have no idea where you are getting those routine names, but my source does not 
have them, unless something has broken grep on my system.

Larry
