Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from arrakis.dune.hu ([78.24.191.176]:48971 "EHLO arrakis.dune.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751204AbcBEKY6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Feb 2016 05:24:58 -0500
Subject: Re: Finer grained control than ap_isolate
To: brian demsky <bdemsky2@gmail.com>, linux-wireless@vger.kernel.org
References: <CAD_1dL31XZeZBgtiESJMGLK8Jn5hDxjoi4F4ViuRHABGowoadw@mail.gmail.com>
From: Felix Fietkau <nbd@openwrt.org>
Message-ID: <56B47872.1090402@openwrt.org> (sfid-20160205_112504_186516_EB2858E3)
Date: Fri, 5 Feb 2016 11:24:50 +0100
MIME-Version: 1.0
In-Reply-To: <CAD_1dL31XZeZBgtiESJMGLK8Jn5hDxjoi4F4ViuRHABGowoadw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-02-05 07:22, brian demsky wrote:
> Is there a mechanism that can be used to allow some clients/ports on a
> given SSID and AP to communicate, but to block others from
> communicating?
> 
> In other words, can I implement something like firewall rules between
> clients on the same SSID/AP?
You might be able to use ap_isolate + bridge hairpin mode + ebtables.

- Felix
