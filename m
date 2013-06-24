Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57810 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003Ab3FXPZt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jun 2013 11:25:49 -0400
Date: Mon, 24 Jun 2013 08:26:31 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: stable@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 3.9 4/4] iwlwifi: mvm: reduce the number of supported
 interfaces
Message-ID: <20130624152631.GA13886@kroah.com> (sfid-20130624_172553_217110_C6225AB7)
References: <1372079945-7445-1-git-send-email-emmanuel.grumbach@intel.com>
 <1372079945-7445-4-git-send-email-emmanuel.grumbach@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372079945-7445-4-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 24, 2013 at 04:19:05PM +0300, Emmanuel Grumbach wrote:
> The driver in 3.9 can't support more than one interface
> concurrently. The parameters given to cfg80211 were wrong.
> Next versions are fixed by allowing concurrent interfaces.
> This is why you won't see this patch upstream.

So this isn't an issue in 3.10 at all?

thanks,

greg k-h
