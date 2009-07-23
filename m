Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f213.google.com ([209.85.217.213]:54343 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751658AbZGWUdm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jul 2009 16:33:42 -0400
Received: by gxk9 with SMTP id 9so2167557gxk.13
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2009 13:33:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A68C821.7060208@redfish-solutions.com>
References: <4A612514.4050708@redfish-solutions.com>
	 <4A63DF0B.4010801@redfish-solutions.com>
	 <20090720115244.GC9972@hash.localnet>
	 <4A64C283.6090205@redfish-solutions.com>
	 <43e72e890907201247x7df76b75wf6ba2bc2260dbf7a@mail.gmail.com>
	 <4A650331.9020409@redfish-solutions.com>
	 <4A6620B9.4@redfish-solutions.com>
	 <20090723112428.GC13742@hash.localnet>
	 <b6c5339f0907230459g75cef6eag1ad0caa7b1a631b8@mail.gmail.com>
	 <4A68C821.7060208@redfish-solutions.com>
Date: Thu, 23 Jul 2009 16:33:41 -0400
Message-ID: <b6c5339f0907231333x1eda7a30s238801d0983292f5@mail.gmail.com>
Subject: Re: Using compat-wireless w/ 2.6.27.26
From: Bob Copeland <me@bobcopeland.com>
To: "Philip A. Prindeville" <philipp_subx@redfish-solutions.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 23, 2009 at 4:29 PM, Philip A.
Prindeville<philipp_subx@redfish-solutions.com> wrote:

> Getting closer :-)
>
> ath5k_tx_processq(sc, &sc->txqs[i]);

Yeah I spotted it on my next compile but then didn't want to send
yet-another-email... Oh well :)  Thanks!


-- 
Bob Copeland %% www.bobcopeland.com
