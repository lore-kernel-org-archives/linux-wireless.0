Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtps.newmedia-net.de ([185.84.6.167]:44871 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751327AbeBTOlX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 09:41:23 -0500
Subject: Re: [PATCH v7] ath10k: add LED and GPIO controlling support for
 various chipsets
To: Bo YU <tsu.yubo@gmail.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
        ath10k@lists.infradead.org,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
References: <20180220073259.17254-1-s.gottschall@dd-wrt.com>
 <20180220130725.GA5134@yubo-2>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <92dac486-285f-f4a0-8b25-6f0d30092580@dd-wrt.com> (sfid-20180220_154126_516004_3AEE7B36)
Date: Tue, 20 Feb 2018 15:41:14 +0100
MIME-Version: 1.0
In-Reply-To: <20180220130725.GA5134@yubo-2>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


>>
>> +struct ath10k_gpiocontrol {
>> +    struct ath10k *ar;
>> +    u32 gpio_set_num, gpio_num, gpio_input, gpio_pull_type, 
>> gpio_intr_mode, gpio_set; /* since we have no gpio read method, these 
>> are the state variables for debugfs.  */
>
> I think the checkpatch.pl will complain above defintely.
> Best regards,
because of the one liner?


Sebastian


-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Stubenwaldallee 21a, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
