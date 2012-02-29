Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:43700 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964992Ab2B2TBg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 14:01:36 -0500
Received: by wibhm11 with SMTP id hm11so2902374wib.19
        for <linux-wireless@vger.kernel.org>; Wed, 29 Feb 2012 11:01:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120229180929.32495.qmail@stuge.se>
References: <CALx5=V8BDFXD7KGBFia0MAkb2iv3x5dupGXTkKEDJ24DLJVx1g@mail.gmail.com>
	<20120229180929.32495.qmail@stuge.se>
Date: Wed, 29 Feb 2012 11:01:35 -0800
Message-ID: <CAJ-VmokvLTsu3vCP+3UM=_ej43198tDGV0m_XNSibqSEm30qkQ@mail.gmail.com> (sfid-20120229_200140_372197_B9ACB98D)
Subject: Re: [ath9k-devel] Any recommendation of direct access the GPIO from
 specific address ?
From: Adrian Chadd <adrian@freebsd.org>
To: Matt Chen <machen@suse.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I believe sometimes its a switch connected physically to the NIC;
other times its a software controlled GPIO line from the host to the
NIC (eg a keyboard rfkill); sometimes its an ACPI command that
controls the GPIO rfkill line; sometimes its smoething else entirely..
 :)


Arian
