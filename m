Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:43176 "EHLO
	mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaKKWcH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Nov 2014 17:32:07 -0500
Received: by mail-oi0-f44.google.com with SMTP id h136so7783924oig.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Nov 2014 14:32:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <545F4611.3010207@broadcom.com>
References: <CAMP44s2XAmaiK2=BJA3TCW48Uo=5qyT5WsASDsZnOiSNgK6b0A@mail.gmail.com>
	<545F4611.3010207@broadcom.com>
Date: Tue, 11 Nov 2014 16:32:06 -0600
Message-ID: <CAMP44s2V59VDx0s7q5Yr=KvGZNn8ptRJGHS4W8Ja=+ciKZaSzg@mail.gmail.com> (sfid-20141111_233213_156146_3503CBD1)
Subject: Re: brcmfmac not working on ECS LIVA
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
	Franky Lin <frankyl@broadcom.com>,
	Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 9, 2014 at 4:46 AM, Arend van Spriel <arend@broadcom.com> wrote:

> Could you share the nvram obtained from EFI? Also please create a kernel log
> with debug=0xd416.

There you go:
http://people.freedesktop.org/~felipec/dmesg-brcm.txt

-- 
Felipe Contreras
