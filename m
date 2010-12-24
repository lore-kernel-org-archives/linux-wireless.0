Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40489 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752721Ab0LXQqF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Dec 2010 11:46:05 -0500
Subject: Re: iwlwifi: Intel 3945ABG speed issues finally identified.
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Eric Appleman <erappleman@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <loom.20101224T030743-87@post.gmane.org>
References: <loom.20101223T071403-99@post.gmane.org>
	 <loom.20101224T030743-87@post.gmane.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 24 Dec 2010 08:37:28 -0800
Message-ID: <1293208648.3997.54.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-12-23 at 18:08 -0800, Eric Appleman wrote:
> Hmmm.
> 
> Both "fix internal scan" and "stuck queue detection" made the cut for the rc2
> kernel. Said kernel is unaffected by the bug.
> 
> For rc3, "rcu lock" and "move sysfs" both make the cut. "serialize station
> management" barely misses the cut.
> 
> Does the sysfs commit apply to the 3945 or is it only for newer cards?
> 
> -
"move sysfs_create_group to post request firmware" patch only apply to
_agn, not for 3945. so it is not the problem :-(

Wey



