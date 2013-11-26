Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:63442 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848Ab3KZDeP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 22:34:15 -0500
Received: by mail-qa0-f49.google.com with SMTP id ii20so7207188qab.1
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 19:34:13 -0800 (PST)
Received: from xps9000.cristianrodriguez.net (pc-237-108-74-200.cm.vtr.net. [200.74.108.237])
        by mx.google.com with ESMTPSA id ki4sm25118596qeb.0.2013.11.25.19.34.11
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-RC4-SHA bits=128/128);
        Mon, 25 Nov 2013 19:34:13 -0800 (PST)
Message-ID: <529416B2.4050908@opensuse.org> (sfid-20131126_043421_258017_C48388F6)
Date: Tue, 26 Nov 2013 00:34:10 -0300
From: =?ISO-8859-1?Q?Cristian_Rodr=EDguez?= <crrodriguez@opensuse.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: wireless-regdb tarballs invalid contents
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi:

It seems the released tarballs of wireless-regdb are incorrect..

How to reproduce

# wget
https://www.kernel.org/pub/software/network/wireless-regdb/wireless-regdb-2013.10.11.tar.xz

# tar xf wireless-regdb-2013.10.11.tar.xz

# cd wireless-regdb-2013.10.11

# sha1sum -c sha1sum.txt
db.txt: FAILED
sha1sum: WARNING: 1 computed checksum did NOT match

# /usr/sbin/regdbdump regulatory.bin
Database signature verification failed.

Regulatory bin from
http://wireless.kernel.org/download/wireless-regdb/regulatory.bins/latest-regulatory.bin
 are however ok.


Will be cool if someone can fix that..



