Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:18451 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751120AbYLTWoE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 17:44:04 -0500
Subject: Re: [PATCH] mac80211_hwsim: configfs support
From: Pavel Roskin <proski@gnu.org>
To: igor_trindade@yahoo.com.br
Cc: j@w1.fi, johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
In-Reply-To: <700428.4819.qm@web59316.mail.re1.yahoo.com>
References: <700428.4819.qm@web59316.mail.re1.yahoo.com>
Content-Type: text/plain
Date: Sat, 20 Dec 2008 17:44:00 -0500
Message-Id: <1229813040.25682.6.camel@dv> (sfid-20081220_234415_084118_43498FBD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2008-12-20 at 09:48 -0800, Igor Trindade Oliveira wrote:
>  
> +# Mount configfs
> +mount -t configfs none /mydir

The standard directory to mount configfs is /sys/kernel/config.  That
directory is actually created on sysfs by the configfs code (look for
"config" with quotes in fs/configfs/mount.c).  /sys/kernel/config is
mentioned in Documentation/networking/netconsole.txt.  You may want to
use the standard path as well.

-- 
Regards,
Pavel Roskin
