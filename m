Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:59795 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbbBEHY0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Feb 2015 02:24:26 -0500
Received: by mail-oi0-f46.google.com with SMTP id a141so5232988oig.5
        for <linux-wireless@vger.kernel.org>; Wed, 04 Feb 2015 23:24:26 -0800 (PST)
Message-ID: <54D31AA8.6060502@lwfinger.net> (sfid-20150205_082431_666127_D662D3E5)
Date: Thu, 05 Feb 2015 01:24:24 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ken D'Ambrosio <ken@jots.org>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8192ee (Thinkpad T440s)
References: <10a90ab7a6c186362f339481b531832f@webmail.jots.org> <54D00FA4.2060907@lwfinger.net> <8f26bf9461a88199ef8d8c86f7ee98f9@webmail.jots.org>
In-Reply-To: <8f26bf9461a88199ef8d8c86f7ee98f9@webmail.jots.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/05/2015 12:56 AM, Ken D'Ambrosio wrote:
> Feb  5 01:51:19 minasithil kernel: [ 3141.801171] rtl8192ee 0000:03:00.0:
> Refused to change power state, currently in D3

Above is the serious problem. The wifi device is not powering on. Sometimes this 
can be caused by some state left by Windows. Do you dual boot?

Do any ACPI warning messages appear in the early boot log?

I found some mention of a module named thinkpad_acpi. Is it loaded?

I have asked the Realtek people if they have any suggestions.

Larry

