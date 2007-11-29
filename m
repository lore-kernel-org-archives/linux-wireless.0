Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3549 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757850AbXK2W21 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Nov 2007 17:28:27 -0500
Date: Thu, 29 Nov 2007 17:26:41 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
Subject: Re: Please pull 'upstream' branch of rt2x00
Message-ID: <20071129222641.GE32730@tuxdriver.com> (sfid-20071129_222830_709747_B624E85B)
References: <200711272146.53518.IvDoorn@gmail.com> <200711272154.29350.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200711272154.29350.IvDoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 27, 2007 at 09:54:29PM +0100, Ivo van Doorn wrote:

> > Please merge the patches for 2.6.24

> Sorry that should be:
> 08 - Only update rssi average approximation on receiving beacon frames.
> 09 - Remove redundant code in rfkill setup
> 10 - Cleanup rfkill

Actually it looks to me like 9 and 10 apply to code that isn't in
2.6.24.  8 looks like it is close, but it doesn't quite apply either.
I'll try to massage it in -- hopefully Jeff won't mind the extra
trouble when rebasing...

John
-- 
John W. Linville
linville@tuxdriver.com
