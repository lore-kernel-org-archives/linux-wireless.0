Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:61173 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038AbZJTXUe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Oct 2009 19:20:34 -0400
Received: by iwn8 with SMTP id 8so3204934iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 20 Oct 2009 16:20:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <411169.20125.qm@web55305.mail.re4.yahoo.com>
References: <200910202112.30660.kunal.gangakhedkar@gmail.com>
	<411169.20125.qm@web55305.mail.re4.yahoo.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 21 Oct 2009 08:20:18 +0900
Message-ID: <43e72e890910201620l3e475630wbde71f34fca3b6df@mail.gmail.com>
Subject: Re: [ath9k-devel] Test for N-mode from userspace?
To: austinxxh-ath9k@yahoo.com
Cc: ath9k-devel@lists.ath9k.org,
	Kunal Gangakhedkar <kunal.gangakhedkar@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 21, 2009 at 2:28 AM, xxiao <austinxxh-ath9k@yahoo.com> wrote:
> interesting, why is MCS range just 0-7, which means no HT?

MCS 1-7 is for single stream devices.

http://wireless.kernel.org/en/developers/Documentation/ieee80211/802.11n

  Luis
