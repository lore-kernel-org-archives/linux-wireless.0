Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59744 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaCCUpP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 15:45:15 -0500
Date: Mon, 3 Mar 2014 15:34:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Gustavo Padovan <gustavo@padovan.org>,
	linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth-next 2014-02-28
Message-ID: <20140303203444.GE26300@tuxdriver.com> (sfid-20140303_214549_573860_81B88B28)
References: <20140228193819.GA1700@joana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140228193819.GA1700@joana>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 28, 2014 at 04:38:19PM -0300, Gustavo Padovan wrote:
> Hi John,
> 
> Another pull request to 3.15. Here we have the second part of the LE private
> feature, the LE auto-connect feature and improvements to the power off
> procedures. The rest are small improvements, clean up, and fixes.
> 
> Please pull or let me know of any problem. Thanks.
> 
> 	Gustavo
> 
> ---
> 
> The following changes since commit 668b7b19820b0801c425d31cc27fd6f499050e5c:
> 
>   Bluetooth: Fix iterating wrong list in hci_remove_irk() (2014-02-21 11:07:46 -0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next.git for-upstream
> 
> for you to fetch changes up to 81ad6fd9698f659dbabdc6cd3e1667a98eb2be3b:
> 
>   Bluetooth: Remove unnecessary stop_scan_complete function (2014-02-28 10:28:17 -0800)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
