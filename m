Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:36948 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755331Ab3JNAPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 13 Oct 2013 20:15:14 -0400
Received: by mail-ob0-f173.google.com with SMTP id wo20so4325034obc.32
        for <linux-wireless@vger.kernel.org>; Sun, 13 Oct 2013 17:15:13 -0700 (PDT)
Message-ID: <525B3790.8040400@lwfinger.net> (sfid-20131014_021519_435000_A5E1A79E)
Date: Sun, 13 Oct 2013 19:15:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: dwmw2@infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: Add new firmware files for rtl8192cu
References: <1380234392-31062-1-git-send-email-Larry.Finger@lwfinger.net>	 <52541E22.2040904@lwfinger.net> <1381691458.1301.63.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1381691458.1301.63.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/13/2013 02:10 PM, Ben Hutchings wrote:
> On Tue, 2013-10-08 at 10:00 -0500, Larry Finger wrote:
>> On 09/26/2013 05:26 PM, Larry Finger wrote:
>>> The vendor driver rtl8188C_8192C_8192D_usb_linux_v3.4.2_3727.20120404
>>> includes new firmware files. These were extracted from data statements
>>> in that driver to form these files.
>>>
>>> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
>>> ---
>>>    WHENCE                       |   3 +++
>>>    rtlwifi/rtl8192cufw_A.bin    | Bin 0 -> 16116 bytes
>>>    rtlwifi/rtl8192cufw_B.bin    | Bin 0 -> 16096 bytes
>>>    rtlwifi/rtl8192cufw_TMSC.bin | Bin 0 -> 16116 bytes
>>>    4 files changed, 3 insertions(+)
>>>    create mode 100644 rtlwifi/rtl8192cufw_A.bin
>>>    create mode 100644 rtlwifi/rtl8192cufw_B.bin
>>>    create mode 100644 rtlwifi/rtl8192cufw_TMSC.bin
>>
>> I understand that you probably have too much to do, but I am inquiring about the
>> status of this submission and "[PATCH] rtlwifi: Add new firmware files for
>> rtl8188eu" that I sent on 09/27/2013.
> [...]
>
> I don't seem to have received them, but I assume the patches you sent
> after this are the same again.

Yes. I found the problem that caused you not to receive them.

Thanks,

Larry


