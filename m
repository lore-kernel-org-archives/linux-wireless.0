Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38172 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951Ab2DMSC3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Apr 2012 14:02:29 -0400
Date: Fri, 13 Apr 2012 13:52:34 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org, arik@wizery.com
Subject: Re: [PATCH 01/16] wireless/wl12xx/wl1251: move TI WLAN modules to a
 common ti subdirectory
Message-ID: <20120413175234.GC2616@tuxdriver.com> (sfid-20120413_200233_971749_D5C42818)
References: <1334137083-13490-1-git-send-email-coelho@ti.com>
 <1334137083-13490-2-git-send-email-coelho@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1334137083-13490-2-git-send-email-coelho@ti.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 11, 2012 at 12:37:48PM +0300, Luciano Coelho wrote:
> Move wl12xx and wl1251 modules into a new drivers/net/wireless/ti
> directory.  Add a TI WLAN Kconfig option and Makefile to support this
> change.
> 
> Signed-off-by: Luciano Coelho <coelho@ti.com>
> Cc: John W. Linville <linville@tuxdriver.com>

ACK

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
