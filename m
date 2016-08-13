Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0064.hostedemail.com ([216.40.44.64]:37496 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751418AbcHME7d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Aug 2016 00:59:33 -0400
Message-ID: <1471064367.3467.8.camel@perches.com> (sfid-20160813_065936_945237_763DE5F5)
Subject: Re: [PATCH 1/2] etherdevice: add is_zero_ether_addr_unaligned()
From: Joe Perches <joe@perches.com>
To: Petri Gynther <pgynther@google.com>
Cc: linux-wireless@vger.kernel.org, kvalo@codeaurora.org,
	David Miller <davem@davemloft.net>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 12 Aug 2016 21:59:27 -0700
In-Reply-To: <CAGXr9JHXdQxObUJC_=4ZaJKmvFS+QygK8ytMtXCJJws62a8S7A@mail.gmail.com>
References: <1471057200-58166-1-git-send-email-pgynther@google.com>
	 <1471061519.3467.7.camel@perches.com>
	 <CAGXr9JHXdQxObUJC_=4ZaJKmvFS+QygK8ytMtXCJJws62a8S7A@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2016-08-12 at 21:40 -0700, Petri Gynther wrote:
> But, we need to return true (1) when the bitwise OR result is zero.
> Same logic as in is_zero_ether_addr().

right.
