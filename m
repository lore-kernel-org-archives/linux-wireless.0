Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:45351 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756496Ab3ANQNh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jan 2013 11:13:37 -0500
Received: by mail-la0-f46.google.com with SMTP id fq13so4062084lab.33
        for <linux-wireless@vger.kernel.org>; Mon, 14 Jan 2013 08:13:36 -0800 (PST)
Message-ID: <50F42EAC.40005@gmail.com> (sfid-20130114_171341_687740_A5C766A1)
Date: Mon, 14 Jan 2013 17:13:32 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: ath9k-devel@lists.ath9k.org dead ??  Fwd: Delivery Status Notification
 (Delay)
References: <047d7b621b90b55bd304d341d180@google.com>
In-Reply-To: <047d7b621b90b55bd304d341d180@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,

is ath9k-devel@lists.ath9k.org alive ?

-------- Original Message --------
Subject: Delivery Status Notification (Delay)
Date: Mon, 14 Jan 2013 16:05:51 +0000
From: Mail Delivery Subsystem <mailer-daemon@googlemail.com>
To: xose.vazquez@gmail.com

This is an automatically generated Delivery Status Notification

THIS IS A WARNING MESSAGE ONLY.

YOU DO NOT NEED TO RESEND YOUR MESSAGE.

Delivery to the following recipient has been delayed:

     ath9k-devel@lists.ath9k.org

Message will be retried for 2 more day(s)

Technical details of temporary failure: 
The recipient server did not accept our requests to connect. Learn more at http://support.google.com/mail/bin/answer.py?answer=7720 
[(0) lists.ath9k.org. [194.45.26.84]:25: Connection refused]

----- Original message -----

DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:message-id:date:from:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        bh=xqctgQzI0LK3bCpj+73VZ3QyMn2PV0OVIHeGJAfJHCU=;
        b=M9s64jWFyUQC/7YyUYCEyYKDvZWI7dKIZqzIco1CkTe2++8wGYSfkuA55hattkPhXM
         VrYTuU3xcSmnju2/vRYcUmBoZ3m/rfn3bTxu99sK+rfpdEPsYcZkZGLSpxAyUNWn3ArV
         SqBZzJUlDbYAR/D2Yhh1lotLdl4luuFmQV5ehE15Yd2e9QhUUPz7RjDZM4Jz2kXL7NZH
         x3E7ZHHR1O7KgpYA82u/LpE/XBXMwakBOR8tf2OqbMgObFvuTCXox0idsR02kdp0PNqQ
         04YxxXMVXAHh3uoP4BjgQ8YJ8sjaAmOiRtzSj1LTrIzL2Pu0mGJnJVbVD6P9/tHjK1SB
         Hrtw==
X-Received: by 10.14.219.3 with SMTP id l3mr220164547eep.5.1358087265412;
        Sun, 13 Jan 2013 06:27:45 -0800 (PST)
Return-Path: <xose.vazquez@gmail.com>
Received: from localhost (88.45.218.87.dynamic.jazztel.es. [87.218.45.88])
        by mx.google.com with ESMTPS id f6sm17558343eeo.7.2013.01.13.06.27.43
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sun, 13 Jan 2013 06:27:44 -0800 (PST)
Message-ID: <50F2C45D.5080204@gmail.com>
Date: Sun, 13 Jan 2013 15:27:41 +0100
From: Xose Vazquez Perez <xose.vazquez@gmail.com>
User-Agent: Polo rio abaixo vai unha troita de pe, corre que te corre, quen a puidera coller...
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>, 
 ath9k-devel@lists.ath9k.org
Subject: Re: ath9k bugs
References: <50F2C327.3040302@gmail.com>
In-Reply-To: <50F2C327.3040302@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 01/13/2013 03:22 PM, Xose Vazquez Perez wrote:

> I also see the same bug with openwrt ATTITUDE ADJUSTMENT (12.09-rc1, r34185)
> on a Buffalo WZR-HP-G300NH device:
> https://dev.openwrt.org/ticket/9654

sorry, this was https://dev.openwrt.org/ticket/12623




