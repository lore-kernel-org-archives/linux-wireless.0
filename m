Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38324 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932211AbZJ0VBO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Oct 2009 17:01:14 -0400
Date: Tue, 27 Oct 2009 16:59:13 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Charles Gordon <digigordo@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: iwlist wlan0 scan disrupts communications
Message-ID: <20091027205913.GF15566@tuxdriver.com>
References: <86201b3f0910271340t51aa6c0bgff43e6e7211a0dee@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <86201b3f0910271340t51aa6c0bgff43e6e7211a0dee@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 27, 2009 at 04:40:46PM -0400, Charles Gordon wrote:

> I am using version 2.6.28 of the kernel and version 0.9.11-nogit of
> iw.  Communications are disrupted and the device stops responding to
> ping when I use the command "iwlist wlan0 scan".  Communications are
> restored when the command completes.  Is this behavior expected?  Has
> it been fixed in a later release?

The device has to change frequencies to conduct the scan.  Kinda like
missing part of a show while you are flipping channels... :-)

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
