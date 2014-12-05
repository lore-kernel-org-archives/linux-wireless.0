Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:49561 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbaLETFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Dec 2014 14:05:20 -0500
Received: by mail-ob0-f181.google.com with SMTP id gq1so970704obb.26
        for <linux-wireless@vger.kernel.org>; Fri, 05 Dec 2014 11:05:19 -0800 (PST)
Date: Fri, 5 Dec 2014 13:04:58 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: wireless-regdb@lists.infradead.org, linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] wireless-regdb: Update keys and maintainer information
Message-ID: <20141205190458.GD40007@ubuntu-hedt> (sfid-20141205_200642_714904_927D1FB1)
References: <20141205163134.GC13629@ubuntu-mba51>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20141205163134.GC13629@ubuntu-mba51>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 05, 2014 at 10:31:34AM -0600, Seth Forshee wrote:
> As announced by John [1], I'm taking over maintaintership of the
> wireless regulatory databse. Make it official by adding my key,
> removing John's, and updating the Makefile and documentation to
> reflect the change in maintainer.
> 
> [1] http://permalink.gmane.org/gmane.linux.kernel.wireless.general/131573

Also I should point out that the new location for the git repo is:

 git://git.kernel.org/pub/scm/linux/kernel/git/sforshee/wireless-regdb.git

I'll be sending patches shortly to update this in the kernel
documentation and in CRDA.

Seth
