Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36542 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752435Ab1EZOLb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 May 2011 10:11:31 -0400
Received: by gyd10 with SMTP id 10so289884gyd.19
        for <linux-wireless@vger.kernel.org>; Thu, 26 May 2011 07:11:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <BANLkTikavLsFOizFG1RieEZNwngBj5Bg0w@mail.gmail.com>
References: <BANLkTimrSD-zB5q+oM=8HkZ1nsTUNEG81g@mail.gmail.com>
	<BANLkTinaz4tmMSTRN7RJgYjOvchLY9NKog@mail.gmail.com>
	<BANLkTin=+9jZvm0RjBN0VGG50EXsnqcdvQ@mail.gmail.com>
	<BANLkTikavLsFOizFG1RieEZNwngBj5Bg0w@mail.gmail.com>
Date: Thu, 26 May 2011 22:11:30 +0800
Message-ID: <BANLkTi=HQe_sVQOcsNN6CUJUEQDpqr2y=g@mail.gmail.com> (sfid-20110526_161143_576227_10CF9F56)
Subject: Re: [ath9k-devel] [PATCH] ath9k: Fix Kiwi (AR9287) initial calibration
From: Adrian Chadd <adrian@freebsd.org>
To: Mohammed Shafi <shafi.ath9k@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	ath9k-devel <ath9k-devel@lists.ath9k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 May 2011 21:15, Mohammed Shafi <shafi.ath9k@gmail.com> wrote:

>> What about RX sensitivity/errors?
>
> should I look recv debug stats?

I'm not a chip developer, so I don't really know. :)

I hazard a guess that the rx calibration will affect RX sensitivity,
maybe CRC errors? Or maximum link distance?


Adrian
