Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from merlin.infradead.org ([205.233.59.134]:38921 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2DEG6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Apr 2012 02:58:02 -0400
Message-ID: <1333609592.19476.1.camel@sortiz-mobl> (sfid-20120405_085806_738549_DFFD9C4F)
Subject: Re: userspace for nfc
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Pavan Savoy <pavan_savoy@sify.com>
Cc: linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
Date: Thu, 05 Apr 2012 09:06:32 +0200
In-Reply-To: <CABUK1ajPrNoGoMm7N_XFGyO9tcnzRj5Ms3-_hLR04xa4yoxhkw@mail.gmail.com>
References: <CABUK1ajPrNoGoMm7N_XFGyO9tcnzRj5Ms3-_hLR04xa4yoxhkw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Pavan,


On Wed, 2012-04-04 at 15:37 -0500, Pavan Savoy wrote:
> Hi,
> 
> Where are the user-space tools to kick start NFC (NCI in kernel) hosted ?
The user space stack is here:

git://git.kernel.org/pub/scm/network/nfc/neard.git


> Any Documentation on it ?
The doc/ directory documents the D-Bus APIs.

Cheers,
Samuel.

