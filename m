Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f199.google.com ([209.85.212.199]:63686 "EHLO
	mail-vw0-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628AbZGIRsE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2009 13:48:04 -0400
Received: by vwj37 with SMTP id 37so282495vwj.33
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2009 10:48:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890907091002r2dd36efevbfbce06155beb7e5@mail.gmail.com>
References: <6c354a1a0906301524m389d49a9sfd812e1ea4740ff5@mail.gmail.com>
	 <b6c5339f0907020836n6162e8b8k3c1a7a24c335ac41@mail.gmail.com>
	 <6c354a1a0907050513x3a3c91b3vb4b9de7196da1a14@mail.gmail.com>
	 <6c354a1a0907061835g438d65daw38b08b9d55081f43@mail.gmail.com>
	 <20090707030719.GC7199@hash.localnet>
	 <6c354a1a0907072358u7408d865h5b32c587f63f39d@mail.gmail.com>
	 <20090708114252.GG7199@hash.localnet>
	 <6c354a1a0907090942o66c4e1b8ue2c952cf7ed7bf9a@mail.gmail.com>
	 <b6c5339f0907090955v7b99a7ebq26e7cc67ab2493f5@mail.gmail.com>
	 <43e72e890907091002r2dd36efevbfbce06155beb7e5@mail.gmail.com>
Date: Thu, 9 Jul 2009 13:48:02 -0400
Message-ID: <b6c5339f0907091048v665dcdf6i659e94de95038856@mail.gmail.com>
Subject: Re: kernel .30 BROKE ATH5K with my AR5212 atheros.
From: Bob Copeland <me@bobcopeland.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Jasin Colegrove <j.wholesalesupply@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 9, 2009 at 1:02 PM, Luis R. Rodriguez<mcgrof@gmail.com> wrote:

>>> $git bisect start v2.6.30-rc4 v2.6.29 -- drivers/net net/

> I'd add net/mac80211 and net/wireless in there as well, just to be safe.

net/ was already in there :)

-- 
Bob Copeland %% www.bobcopeland.com
