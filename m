Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:54672 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134AbaGaRpN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jul 2014 13:45:13 -0400
Date: Thu, 31 Jul 2014 13:38:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-07-31
Message-ID: <20140731173820.GC17560@tuxdriver.com> (sfid-20140731_194546_092530_5F68A287)
References: <20140731074357.GA26071@t440s.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140731074357.GA26071@t440s.lan>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 31, 2014 at 10:43:57AM +0300, Johan Hedberg wrote:
> Hi John,
> 
> Here's one more (hopefully last) pull request for 3.17.
> 
> We've got:
> 
> - 6lowpan fixes/cleanups
> - A couple crash fixes, one for the Marvell HCI driver and another in LE SMP.
> - Fix for an incorrect connected state check
> - Fix for the bondable requirement during pairing (an issue which had
>   crept in because of using "pairable" when in fact the actual meaning
>   was "bondable" (these have different meanings in Bluetooth)
> 
> Let me know if there are any issues. Thanks.
> 
> Johan
> 
> ---
> The following changes since commit 568ba389be505f505b7fbeedb9ab4ece27603fc9:
> 
>   brcmfmac: Fix OOB interrupt not working for BCM43362 (2014-07-29 10:32:57 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 8500d791c458ccbbb3e2d3fa9a0320ffd5729069:
> 
>   Bluetooth: Fix crash in the Marvell driver initialization codepath (2014-07-31 01:07:28 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
