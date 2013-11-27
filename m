Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41014 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753624Ab3K0QeQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Nov 2013 11:34:16 -0500
Date: Wed, 27 Nov 2013 11:32:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Cristian =?iso-8859-1?Q?Rodr=EDguez?= <crrodriguez@opensuse.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless-regdb tarballs invalid contents
Message-ID: <20131127163207.GA7780@tuxdriver.com> (sfid-20131127_173419_512866_45B0FE68)
References: <529416B2.4050908@opensuse.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <529416B2.4050908@opensuse.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 26, 2013 at 12:34:10AM -0300, Cristian Rodríguez wrote:
> Hi:
> 
> It seems the released tarballs of wireless-regdb are incorrect..
> 
> How to reproduce
> 
> # wget
> https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2013.10.11.tar.xz
> 
> # tar xf wireless-regdb-2013.10.11.tar.xz
> 
> # cd wireless-regdb-2013.10.11
> 
> # sha1sum -c sha1sum.txt
> db.txt: FAILED
> sha1sum: WARNING: 1 computed checksum did NOT match
> 
> # /usr/sbin/regdbdump regulatory.bin
> Database signature verification failed.
> 
> Regulatory bin from
> http://wireless.kernel.org/download/wireless-regdb/regulatory.bins/latest-regulatory.bin
>  are however ok.
> 
> 
> Will be cool if someone can fix that..

I have released an update (e.g. 2013-11-27).  Please confirm that
the signature is working for you.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
