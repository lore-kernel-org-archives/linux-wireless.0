Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpoproxy1-pub.bluehost.com ([69.89.21.11]:60349 "HELO
	cpoproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753314Ab0FRUHQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jun 2010 16:07:16 -0400
Date: Fri, 18 Jun 2010 13:05:38 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org,
	linux-scsi@vger.kernel.org
Subject: Re: [PATCH 4/5]pci:setup_bus.c Fix warning: variable 'retval' set
 but not used
Message-ID: <20100618130538.0fc562ee@virtuousgeek.org>
In-Reply-To: <4C1BD024.1030707@gmail.com>
References: <1276666434-11227-1-git-send-email-justinmattock@gmail.com>
	<1276666434-11227-5-git-send-email-justinmattock@gmail.com>
	<20100618102330.29eccb5b@virtuousgeek.org>
	<4C1BBF7D.8090904@kernel.org>
	<20100618124956.40c869a0@virtuousgeek.org>
	<4C1BD024.1030707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 18 Jun 2010 12:59:32 -0700
"Justin P. Mattock" <justinmattock@gmail.com> wrote:
> just added this in(as a test), and the retval warning still shows up.
> with the last post I just added a printk was that legit, and if so what 
> else might be added to it to make it complete and proper?

What's the full warning?  Seems like printing the value should have
been enough to shut up gcc...

-- 
Jesse Barnes, Intel Open Source Technology Center
