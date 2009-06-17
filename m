Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f213.google.com ([209.85.218.213]:63936 "EHLO
	mail-bw0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752146AbZFQG35 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Jun 2009 02:29:57 -0400
Received: by bwz9 with SMTP id 9so82079bwz.37
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 23:29:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <d618c7af0906161532y40d039c6xa69333c6a5461f2b@mail.gmail.com>
References: <d618c7af0906161532y40d039c6xa69333c6a5461f2b@mail.gmail.com>
Date: Wed, 17 Jun 2009 07:29:58 +0100
Message-ID: <3ace41890906162329i52b5547ag9e06afaf93e2dc4d@mail.gmail.com>
Subject: Re: Support for TrendNET TEW-509UB in zd1211rw
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Jordan Naas <jordan.matthew02@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2009 at 11:32 PM, Jordan Naas<jordan.matthew02@gmail.com> wrote:
> I have a TrendNet TEW-509UB wifi adapter from trendnet with USB id
> 157e:3207.  I have added it manually and recompiled the driver and it
> functions correctly.  If the ID could be added to the supported
> devices I would greatly appreciate it.

Is it a B or a non-B device? Ideally we'll need the couple of id lines
from your dmesg
just for the record. (the one which says what RF it has).
