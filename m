Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45922 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab2AaHtr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 Jan 2012 02:49:47 -0500
Received: by dadi2 with SMTP id i2so4276777dad.19
        for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 23:49:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120130191820.F4F520E8@centrum.cz>
References: <20120128154544.70E060CD@centrum.cz>
	<1385650.dcoDil3T5I@helmutmobil.site>
	<20120130191820.F4F520E8@centrum.cz>
Date: Tue, 31 Jan 2012 08:49:46 +0100
Message-ID: <CAGXE3d_wHuNT7Q+Ubj5qR-DgA78AeYXe7MfnFS4rv+iHjtMJbA@mail.gmail.com> (sfid-20120131_084950_152464_3DBC31C1)
Subject: Re: connection interrupted for rt61pci in master mode
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: trencan@centrum.cz
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 30, 2012 at 7:18 PM,  <trencan@centrum.cz> wrote:
> I made the test again, got connection interrupted on client, but folder
> "/sys/kernel/debug/ieee80211/phy0/" was empty on server, no rt2800pci
> inside. Do I make anything wrongly?

Hmm, rt2x00 needs to be build with debug/debugfs support:

CONFIG_RT2X00_LIB_DEBUGFS
CONFIG_RT2X00_DEBUG

Helmut
