Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:34223 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbcAXLqB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 24 Jan 2016 06:46:01 -0500
Received: by mail-lb0-f175.google.com with SMTP id cl12so61201025lbc.1
        for <linux-wireless@vger.kernel.org>; Sun, 24 Jan 2016 03:46:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56A4A837.5030509@gmail.com>
References: <bug-110551-148371@https.bugzilla.kernel.org/>
	<bug-110551-148371-jY9LWPEyBc@https.bugzilla.kernel.org/>
	<56A4A837.5030509@gmail.com>
Date: Sun, 24 Jan 2016 13:45:59 +0200
Message-ID: <CANUX_P3CARmHDJ5gpdOdo3ppcRBmZx7j0vqwaHKLPnmwDhLjww@mail.gmail.com> (sfid-20160124_124641_868807_5620A251)
Subject: Re: [Bug 110551] iwlwifi: dvm: cannot turn off wifi LED
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Hubert Tarasiuk <hubert.tarasiuk@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	bugzilla-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jan 24, 2016 at 12:32 PM, Hubert Tarasiuk
<hubert.tarasiuk@gmail.com> wrote:
> Attached is the patch for bug 110551.
>
> W dniu 24.01.2016 o 11:16, bugzilla-daemon@bugzilla.kernel.org pisze:
>> https://bugzilla.kernel.org/show_bug.cgi?id=110551
>>
>> --- Comment #13 from Emmanuel Grumbach <emmanuel.grumbach@intel.com> ---
>> https://bugzilla.kernel.org/attachment.cgi?id=201271
>>
>> This one seems to have a fix for the module param as well.
>> I would much prefer you to send the patch to the wireless mailing list rather
>> than attaching it to this bugzilla.
>>

The better way is send the patches with git-send-email tool.
