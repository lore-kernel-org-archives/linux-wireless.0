Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f214.google.com ([209.85.219.214]:60463 "EHLO
	mail-ew0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbZHKPLY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Aug 2009 11:11:24 -0400
Received: by ewy10 with SMTP id 10so3852075ewy.37
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2009 08:11:24 -0700 (PDT)
Subject: Re: Roaming behavior
From: David Seira <davidseira@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <20090811135915.GC2684@tuxdriver.com>
References: <loom.20090811T124332-602@post.gmane.org>
	 <20090811135915.GC2684@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Aug 2009 17:11:21 +0200
Message-Id: <1250003481.4185.7.camel@solid2>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

El mar, 11-08-2009 a las 09:59 -0400, John W. Linville escribió:
> On Tue, Aug 11, 2009 at 12:44:51PM +0000, David Seira wrote:
> 
> > I asked in the ath5k-user list about how to change roaming behavior of
> > ath5k. Pavel Roskin told me that I asked here.
> > I need to modify the roaming behavior, where can I do this?
> 
> This is mostly in the hands of wpa_supplicant...what modifications
> do you want to make?
> 
> John

Hi.
I want to delete this behavior because I'm developing an application
which do that alone.

Thanks for all,
David

P.D: I have an OpenWRT r16278. The files that I want to modify were in
compat-wireless-2009-05-21, but I don't know which are.

