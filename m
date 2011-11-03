Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26802 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934073Ab1KCQ4b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Nov 2011 12:56:31 -0400
Message-ID: <4EB2C7B8.7020009@qca.qualcomm.com> (sfid-20111103_175635_145459_1ABCD171)
Date: Thu, 3 Nov 2011 18:56:24 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: don't power down hardware when interface is down
References: <20111103095357.10733.85983.stgit@localhost6.localdomain6>
In-Reply-To: <20111103095357.10733.85983.stgit@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/03/2011 11:53 AM, Kalle Valo wrote:
> Jouni reported that my patch "ath6kl: power down hardware when interface
> is down" caused a regression on his x86 boxes and scan didn't work anymore.
> I was able to reproduce the problem by disabling all debug messages.
> 
> So there has to be a race condition somewhere in the code and disable the
> functionality until the race is fixed. Now hardware is powered from the
> point where module is loaded until it's removed.

Applied.

Kalle
