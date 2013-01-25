Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f45.google.com ([74.125.82.45]:62034 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932086Ab3AYMN2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Jan 2013 07:13:28 -0500
Received: by mail-wg0-f45.google.com with SMTP id dq12so193405wgb.12
        for <linux-wireless@vger.kernel.org>; Fri, 25 Jan 2013 04:13:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <2074978.Uifvhs4VDD@sylvesterjr.pats.ua.ac.be>
References: <2074978.Uifvhs4VDD@sylvesterjr.pats.ua.ac.be>
Date: Fri, 25 Jan 2013 13:13:27 +0100
Message-ID: <CAGXE3d9+XjVA4GNc37mZyNjE59xom2FMDhNZx_DFyzax8eXfkQ@mail.gmail.com> (sfid-20130125_131333_641017_0818293F)
Subject: Re: rt2800 does not support HT40 in managed mode
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Erwin Van de Velde <erwin.vandevelde@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 25, 2013 at 11:36 AM, Erwin Van de Velde
<erwin.vandevelde@gmail.com> wrote:
> In a lab setup, we configured rt2800 + hostapd to setup an access point
> in 802.11n 5GHz with HT40. Even though there was no interference, we
> could verify with a Wi-Spy that the network used in fact only a 20MHz wide
> band and iperf showed very low throughput (approx. 10Mbps for a 10m
> line-of-sight connection).

Maybe there were other APs around forcing hostapd to fall back to HT20 (see
ieee80211n_allowed_ht40_channel_pair in hostapd source code)?

Helmut
