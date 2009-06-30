Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f226.google.com ([209.85.217.226]:65379 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731AbZF3Rw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 13:52:28 -0400
Received: by gxk26 with SMTP id 26so469819gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 10:52:31 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20090630170916.GB5137@sprite>
References: <20090630170916.GB5137@sprite>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 30 Jun 2009 10:52:09 -0700
Message-ID: <43e72e890906301052l5a0b8984od8437fefa38e0dff@mail.gmail.com>
Subject: Re: ath5k and Atheros AR242x - No scan results
To: Joel Roth <joelz@pobox.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 30, 2009 at 10:09 AM, Joel Roth<joelz@pobox.com> wrote:

sudo ip link set dev wlan0 up


> $ iwlist wlan0 scan
>
> wlan0     No scan results
