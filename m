Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:44197 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422651AbXC2WAD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Mar 2007 18:00:03 -0400
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HX2cy-0006bM-Ib
	for linux-wireless@vger.kernel.org; Thu, 29 Mar 2007 17:57:52 -0400
Subject: Re: [PATCH 1/5] Meddled with by Andy Green since signed-off: made  it apply to current wireless-dev, took out comments for radiotap types not  in current wireless-dev
From: Pavel Roskin <proski@gnu.org>
To: Andy Green <andy@warmcat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <460C1340.7040700@warmcat.com>
References: <20070329133114.569947199@warmcat.com>
	 <20070329133123.323900095@warmcat.com> <1175195559.12052.14.camel@dv>
	 <460C1340.7040700@warmcat.com>
Content-Type: text/plain
Date: Thu, 29 Mar 2007 18:00:01 -0400
Message-Id: <1175205601.24718.11.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2007-03-29 at 20:28 +0100, Andy Green wrote:

> The file in wireless-2.6 does not seem to have the __le stuff in it?
> Am 
> I looking in the right place at 
> http://ftp.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git?

It should be there:
http://git.kernel.org/?p=linux/kernel/git/linville/wireless-2.6.git;a=commit;h=99f89e33e15d47322a89fac02f2e4d5f4dcee91d

-- 
Regards,
Pavel Roskin

