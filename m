Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:49317 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756170AbaICOKa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 10:10:30 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21511.8546.157916.710879@gargle.gargle.HOWL> (sfid-20140903_161056_006777_E10BB726)
Date: Wed, 3 Sep 2014 19:40:42 +0530
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Robb <rbarr138@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: Cannot get ACS to work with hostapd-2.2 "Unknown event 49"
In-Reply-To: <CA+BoTQnCoZL=GzUh4vJqOQ=-PZ1BwZcUO21spUPB5KF1fUSiRw@mail.gmail.com>
References: <CAOHJ0jTHtVvJ43y7m-=UqHeMJfNiMYU2Peg9buxXU+wBigwu5g@mail.gmail.com>
	<CA+BoTQm+x0kD9m3vVv98MwYOXjfgO1noXOnzdbk5o41S+DLewQ@mail.gmail.com>
	<CAOHJ0jSoSd97vFEMgxC3cC8AnaEGdwbUiBBoeM7UfLJcha0Ujg@mail.gmail.com>
	<CA+BoTQnCoZL=GzUh4vJqOQ=-PZ1BwZcUO21spUPB5KF1fUSiRw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior wrote:
> On 3 September 2014 15:10, Robb <rbarr138@gmail.com> wrote:
> You are making an assumption ath9k == ath9k_htc. This is not correct.
> 
> I would actually suspect the ath9k_htc *chips* actually are capable of
> providing the necessary information to create survey dump but the
> firmware/driver do not support it. Can anyone more familiar with
> ath9k_htc correct me if I'm wrong?

You are correct, the HW MAC for the chips supported by ath9k_htc is mostly the
same as the ones supported by ath9k. But, driver support for survey dump
is lacking.

> If the 9271 doesn't support it then I guess it can only be the
> AR7010+AR9280 or AR7010+AR9287 right? Any way to know which works?

ath9k_htc doesn't provide survey dump data for any USB card.

Sujith
