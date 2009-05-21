Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48768 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbZEUEwi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2009 00:52:38 -0400
To: "Larry H." <research@subreption.com>
Cc: linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
	linux-mm@kvack.org, Ingo Molnar <mingo@redhat.com>,
	pageexec@freemail.hu, linux-wireless@vger.kernel.org
Subject: Re: [patch 2/5] Apply the PG_sensitive flag to mac80211 WEP key handling
References: <20090520184713.GB10756@oblivion.subreption.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Thu, 21 May 2009 07:52:36 +0300
In-Reply-To: <20090520184713.GB10756@oblivion.subreption.com> (Larry H.'s message of "Wed\, 20 May 2009 11\:47\:13 -0700")
Message-ID: <87ljorm50r.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Larry H." <research@subreption.com> writes:

> This patch deploys the use of the PG_sensitive page allocator flag
> within the mac80211 driver, more specifically the handling of WEP
> RC4 keys during encryption and decryption.

Why? Always explain the reason for the change in commit log. For
example, I have no idea why you want to change this.

> Signed-off-by: Larry H. <research@subreption.com>

Please add your last name.

-- 
Kalle Valo
