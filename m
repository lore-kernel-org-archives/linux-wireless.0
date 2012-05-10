Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:48726 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab2EJPtp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 May 2012 11:49:45 -0400
Received: by qcro28 with SMTP id o28so1231497qcr.19
        for <linux-wireless@vger.kernel.org>; Thu, 10 May 2012 08:49:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG9cJm=tJcOnbEfcxV7zyizbUEerO52+NdEGMN13Z0oGmu_2dg@mail.gmail.com>
References: <CAG9cJmkDf6koV93NyOo2W8D7Y3G6tapQOucjW5M7FLPDnNhvKQ@mail.gmail.com>
	<CAGRGNgXDUuLFeKh7KgqMqyyT8Xi_GV2BReYJ66uK_SgBJ5Nb4g@mail.gmail.com>
	<CAG9cJmmRZvf=EW9k6AVLEv_zeU86thGaEWHv5R0ADNX9B6jMmw@mail.gmail.com>
	<CAGRGNgXQ3o-2bD9J+C2cAu9M-fo69tiXWfugZKjqU3o9ki7f7Q@mail.gmail.com>
	<CAG9cJm=tJcOnbEfcxV7zyizbUEerO52+NdEGMN13Z0oGmu_2dg@mail.gmail.com>
Date: Thu, 10 May 2012 23:49:44 +0800
Message-ID: <CAG9cJmnPzdy10F1t+dJ_n4_2t1F5Yr588mDoUWj3B0n3h+d+Qw@mail.gmail.com> (sfid-20120510_174948_908266_8D6FC11A)
Subject: Re: how to remove the b43
From: lina <lina.lastname@gmail.com>
To: Julian Calaby <julian.calaby@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

# aptitude install linux-image-amd64
The following NEW packages will be installed:
  firmware-linux-free{a} linux-base{a} linux-image-3.2.0-2-amd64{a}
  linux-image-amd64

# aptitude install firmware-b43-installer
The following NEW packages will be installed:
  b43-fwcutter{a} firmware-b43-installer


Setting up b43-fwcutter (1:015-14) ...
Setting up firmware-b43-installer (1:015-14) ...
No chroot environment found. Starting normal installation
Unsupported device(s) found: PCI id 14e4:4331
Aborting.

Have I missed something?

Thanks again,
