Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:30906 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbYGUHSY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Jul 2008 03:18:24 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1248885rvb.1
        for <linux-wireless@vger.kernel.org>; Mon, 21 Jul 2008 00:18:22 -0700 (PDT)
Message-ID: <1ba2fa240807210018gbd31c18g59fc08f4a8b2a3ce@mail.gmail.com> (sfid-20080721_091829_485046_9B31E495)
Date: Mon, 21 Jul 2008 10:18:22 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
Subject: Re: [PATCH 0/3] Introducing IWLAGN
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	yi.zhu@intel.com, linux-wireless@vger.kernel.org
In-Reply-To: <20080721012528.GA6623@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1216597215-19708-1-git-send-email-tomas.winkler@intel.com>
	 <20080721012528.GA6623@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 21, 2008 at 4:25 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Mon, 21 Jul 2008, Tomas Winkler wrote:
>> This series of patches renames iwl4965 driver to iwlagn driver
>
> Maybe MODULE_ALIAS with the old name would be a good idea?

I wasn't aware of this one I'll give it a try. Thanks
Tomas
