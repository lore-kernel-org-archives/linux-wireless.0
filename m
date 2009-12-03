Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34149 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbZLCFgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Dec 2009 00:36:11 -0500
Subject: Re: [PATCH] Remove double semicolons
From: Zhu Yi <yi.zhu@intel.com>
To: Joe Perches <joe@perches.com>
Cc: John Daiker <daikerjohn@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Ortiz, Samuel" <samuel.ortiz@intel.com>
In-Reply-To: <1259816171.22783.15.camel@Joe-Laptop.home>
References: <1259813669-29946-1-git-send-email-daikerjohn@gmail.com>
	 <1259816171.22783.15.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Dec 2009 13:36:15 +0800
Message-ID: <1259818575.12157.136.camel@debian>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-12-03 at 12:56 +0800, Joe Perches wrote:
> On Wed, 2009-12-02 at 20:14 -0800, John Daiker wrote:
> > This patches eliminates a few double semicolons in the IWMC3200
> driver.
> 
> How about this instead:
> 
> Avoid an offset calculation for each management frame.
> Determine the offset at compile time.
> 
> Signed-off-by: Joe Perches <joe@perches.com> 

Acked-by: Zhu Yi <yi.zhu@intel.com>

Thanks,
-yi

