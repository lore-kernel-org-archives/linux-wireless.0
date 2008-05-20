Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rn-out-0910.google.com ([64.233.170.190]:39035 "EHLO
	rn-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbYETOYj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 10:24:39 -0400
Received: by rn-out-0910.google.com with SMTP id k40so21597rnd.17
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 07:24:37 -0700 (PDT)
Message-ID: <69e28c910805200724u570c6788m8914187ae7cc0949@mail.gmail.com> (sfid-20080520_162442_842179_EC27EA77)
Date: Tue, 20 May 2008 10:24:36 -0400
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Tomas Winkler" <tomasw@gmail.com>
Subject: Re: iwlwifi injection bug
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	"Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Andy Green" <andy@warmcat.com>
In-Reply-To: <69e28c910805200716i3fd16c33x274983ab8e7591e6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210945631.6381.11.camel@johannes.berg>
	 <1211249729.2532.59.camel@debian.sh.intel.com>
	 <69e28c910805200432lbd3790vb925dacaea3aca83@mail.gmail.com>
	 <1211287111.6252.84.camel@johannes.berg>
	 <69e28c910805200614q2232b21ame8ff03fe4156fb3b@mail.gmail.com>
	 <1ba2fa240805200641j4ccc1de4r5572e1321394a526@mail.gmail.com>
	 <69e28c910805200716i3fd16c33x274983ab8e7591e6@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

BTW I am not sure if the "if (sta_id == IWL_INVALID_STATION)" change
is needed at all - injected packets should have a valid station ID,
due to the "case IEEE80211_IF_TYPE_MNTR" change.
