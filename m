Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:12967 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbZI2LBM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 Sep 2009 07:01:12 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Tomas Winkler <tomasw@gmail.com>
Subject: Re: Firmware versioning best practices
Date: Tue, 29 Sep 2009 13:01:04 +0200
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <43e72e890909281517k23abaf8dvd3e84837ce307429@mail.gmail.com> <200909290859.25075.hs4233@mail.mn-solutions.de> <1ba2fa240909290345k776826a6jc692d9d8dfe7577@mail.gmail.com>
In-Reply-To: <1ba2fa240909290345k776826a6jc692d9d8dfe7577@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200909291301.04156.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > Don't put the version into the filename. This is not a common
> > practice for Linux / BSD / whatever systems. Usually you have
> > a "kmail" file, not a kmail3.5, kmail4.0 and kmail4.2 file.
> 
> I think in this context libyyy.so.x.y.z is better analogy.
> firmware is not an executable What is the reasoning behind this
> common practice? 

There's no version of the library in the file-name, but the 
version of the API. So if the API changes, and might break users 
of the API, you increase the filename.

But you won't have a libc-2.3.6.so file. Instead you have a 
package "libc6_2.3.6.ds1-13etch9_i386.deb" which contains the 
file libc.so.6.

-- 
http://www.holgerschurig.de
