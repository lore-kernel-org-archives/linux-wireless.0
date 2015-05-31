Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38392 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754559AbbEaAix (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 May 2015 20:38:53 -0400
Date: Sun, 31 May 2015 09:00:08 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: Stanislav Kholmanskikh <kholmanskikh.s.s@gmail.com>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: wilc1000: Cleanup to coreconfigurator
Message-ID: <20150531000008.GC20036@kroah.com> (sfid-20150531_023915_329018_7347A6D2)
References: <1433018659-25958-1-git-send-email-kholmanskikh.s.s@gmail.com>
 <1433018659-25958-2-git-send-email-kholmanskikh.s.s@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433018659-25958-2-git-send-email-kholmanskikh.s.s@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 30, 2015 at 11:44:19PM +0300, Stanislav Kholmanskikh wrote:
> Fixed several syntax/style issues found with checkpatch.pl, plus
> aligned structs/enums to follow a common style per struct/enum.

Again, please only do one thing per patch.

thanks,

greg k-h
