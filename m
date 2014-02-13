Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42331 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519AbaBMUAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 15:00:15 -0500
Date: Thu, 13 Feb 2014 14:51:36 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Subject: Re: pull request: iwlwifi 2014-02-13
Message-ID: <20140213195136.GI22203@tuxdriver.com> (sfid-20140213_210119_522350_E84F35E2)
References: <52FCC95D.4090609@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52FCC95D.4090609@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 13, 2014 at 03:32:13PM +0200, Emmanuel Grumbach wrote:
> Hi John,
> 
> One single patch for this pull request for 3.14.
> 
> As explicitly written in the commit message, we prefer to disable Tx
> AMPDU on NICs supported by iwldvm. This feature gives a big boost in Tx
> performance, but the firmware is buggy and we can't rely on it.
> Our hope is that most of the users out there want wifi to surf on the
> web which means that they care more for Rx traffic than for Tx.
> People who want to enable it can do so with the help of a module parameter.
> 
> Please pull - thanks.
> 
> 	emmanuel
> 
> 
> The following changes since commit c512865446e6dd5b6e91e81187e75b734ad7cfc7:
> 
>   iwlwifi: mvm: don't allow A band if SKU forbids it (2014-02-02
> 11:08:42 +0200)
> 
> are available in the git repository at:
> 
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-fixes.git
> master
> 
> for you to fetch changes up to 205e2210daa975d92ace485a65a31ccc4077fe1a:
> 
>   iwlwifi: disable TX AMPDU by default for iwldvm (2014-02-13 15:24:35
> +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
