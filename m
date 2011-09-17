Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f180.google.com ([74.125.82.180]:37153 "EHLO
	mail-wy0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab1IQBd7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Sep 2011 21:33:59 -0400
Received: by wyj26 with SMTP id 26so5320792wyj.11
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2011 18:33:58 -0700 (PDT)
MIME-Version: 1.0
From: Simeon Nifos <archwndas@googlemail.com>
Date: Fri, 16 Sep 2011 18:33:38 -0700
Message-ID: <CAL1uj0zX5gGHkQny7fE3xrVm9HgP3PvC+ff2g7sunzNvXzgu=g@mail.gmail.com> (sfid-20110917_033411_943517_80AC4CCE)
Subject: deactivating one of the two wireless connections
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I have a USB wireless card apart from the laptops one. The Gnome
NetworkManager sees both when I plugin the USB wireless adapter. The
problem is that for saving power I would like to turn off the wireless
adapter of my laptop. However, if I use the laptops switch that turns
off laptops wireless, the Network Manager, turns off both connections
saying: Deactivated by Hardware switch or something similar.

The problem is that I usually want to connect with my wireless USB
adapter which has a directional antenna and provides better signal and
higher download speeds. However, after some minutes automatically by
itself the laptops adapter connects to the same access point and then
I lose the connection. I can do something like:

# ifconfig wlan0 down

and deactivate the laptops adapter, but this is a simple ad-hoc solution.

My impression is that the hardware switch on the keyboard of the
laptop should not control all wireless connections. It is entirely
wrong. If I wnt my USB connection to be deactivated I just unplug it.
If I want to use it I just plug it in. This is how things should be.
Removable devices should be powered on when connected and powered off
when disconnected. For as long as it remains connected that means I
want it to function as it is supposed to do so. I do not see why
switching off my laptop's device switches off every other wireless
device.

Is there any easy fix for that?

Cheers,
Archwn.
