Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61097 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756408Ab3BWAgB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 19:36:01 -0500
Received: by mail-wi0-f171.google.com with SMTP id hn17so1574656wib.10
        for <linux-wireless@vger.kernel.org>; Fri, 22 Feb 2013 16:35:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1361564916.3420.11.camel@jlt4.sipsolutions.net>
References: <A47087626F2942499CF47E79803E771E0431B792@SJEXCHMB13.corp.ad.broadcom.com>
	<1361564916.3420.11.camel@jlt4.sipsolutions.net>
Date: Fri, 22 Feb 2013 16:30:58 -0800
Message-ID: <CAJ-VmokSn-jo9oFm4Udhf=T+HXM2N4g=Ckc-=NQEOKL=j=w5NA@mail.gmail.com> (sfid-20130223_013608_111343_15BF9EBE)
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
From: Adrian Chadd <adrian@freebsd.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend Van Spriel <arend@broadcom.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Piotr Haber <phaber@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

... why not tag such traffic with a higher QOS priority and then have
the BT coex module snoop thaT?



Adrian
