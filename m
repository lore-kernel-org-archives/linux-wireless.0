Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:39460 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755785AbYLMGUf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 13 Dec 2008 01:20:35 -0500
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1LBNrc-0001GI-RU
	for linux-wireless@vger.kernel.org; Sat, 13 Dec 2008 07:20:32 +0100
Message-ID: <c072ca310812120323r2c92420di5a138ae6265d567f@mail.gmail.com> (sfid-20081213_072109_337226_5AC17EF9)
Date: Fri, 12 Dec 2008 16:23:49 +0500
From: "Alexander E. Patrakov" <patrakov@gmail.com>
To: "Zdenek Kabelac" <zkabelac@redhat.com>
Subject: Re: iwlagn interrupt problem
Cc: "reinette chatre"
	<public-reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@hugh.gmane.org>,
	"linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
	<public-linux-kernel-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>,
	"linux-wireless-u79uwXL29TY76Z2rM5mHXA@public.gmane.org"
	<public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org>
In-Reply-To: <49424419.1090103@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <c072ca310812100638k6c15473brb89632a9c175a028@mail.gmail.com>
	 <c072ca310812100710o58c38a27rba16ad2318a1cb95@mail.gmail.com>
	 <1228929548.18730.21.camel@rc-desk>
	 <c072ca310812110548s64612ac7icd6e9187aa4af75a@mail.gmail.com>
	 <49424419.1090103@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>




2008/12/12 Zdenek Kabelac <zkabelac@redhat.com>:
> I assume that this backtrace I've got with 2.6.28-rc7 is the same issue ?

No, this is different. My issue is with unacceptable latency when
bringing the interface down. In your dmesg, the interface was never
brought up or down.

-- 
Alexander E. Patrakov


