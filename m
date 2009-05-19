Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:49772 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751177AbZESSAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 14:00:12 -0400
Date: Tue, 19 May 2009 13:53:36 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Dongas <dongas86@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Throughput is not changed when setting to a much higher bit
	rate
Message-ID: <20090519175336.GF2691@tuxdriver.com>
References: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <60ce8d250905191048t46e3848fw3416ecd793dab9d1@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 20, 2009 at 01:48:32AM +0800, Dongas wrote:

> Why the bandwidth is not changed when bit rate is changed to 11Mb/s?
> Any thing wrong?

More errors at higher bit rate, resulting in more retries?  Just a
thought...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
