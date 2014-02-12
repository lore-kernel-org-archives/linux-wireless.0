Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:55098 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167AbaBLLCW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Feb 2014 06:02:22 -0500
Received: by mail-la0-f49.google.com with SMTP id y1so6886310lam.36
        for <linux-wireless@vger.kernel.org>; Wed, 12 Feb 2014 03:02:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52FB39F0.9010102@gmail.com>
References: <52FB360D.2060502@gmail.com>
	<52FB39F0.9010102@gmail.com>
Date: Wed, 12 Feb 2014 13:02:21 +0200
Message-ID: <CANUX_P3S29q-e4T+KDiBD4h-2O=sqEmuJzmJ1KDPnm9WSpd9=A@mail.gmail.com> (sfid-20140212_120229_881226_F043841E)
Subject: Re: pull request: iwlwifi 2014-02-12 (FIXED)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: John Linville <linville@tuxdriver.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> Hi John,
>>
>> One single patch for this pull request for 3.14.
>>
>> As explicitly written in the commit message, we prefer to disable Tx
>> AMPDU on NICs supported by iwldvm. This feature gives a big boost in Tx
>> performance, but the firmware is buggy and we can't rely on it.
>> Our hope is that most of the users out there want wifi to surf on the
>> web which means that they care more for Rx traffic than for Tx.
>> People who want to enable it can do so with a simple Kconfig entry.
>> Rx AMPDU is still enabled by default.
>>
>> Please pull - thanks.
>>
>>       emmanuel
>>
>> The following changes since commit c512865446e6dd5b6e91e81187e75b734ad7cfc7:
>>
>>   iwlwifi: mvm: don't allow A band if SKU forbids it (2014-02-02
>> 11:08:42 +0200)
>>
>> are available in the git repository at:
>>
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
>> for-john
>>
>> for you to fetch changes up to 930e106d90ca902c8ede0a8cb206cee1ef3c5cc0:
>>
>
> I had to edit the patch - 63f1809aa672dc439e7750b551ff9926a79312e0
>

John - as you can see Stanislaw isn't happy with this. Please don't
pull this right now - I'll try to find an agreed solution.
