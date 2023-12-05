X-Greylist: delayed 448 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 05 Dec 2023 01:06:55 PST
Received: from wens.tw (mirror2.csie.ntu.edu.tw [140.112.30.76])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77914D3
	for <linux-wireless@vger.kernel.org>; Tue,  5 Dec 2023 01:06:55 -0800 (PST)
Received: by wens.tw (Postfix, from userid 1000)
	id DE5A75FCE8; Tue,  5 Dec 2023 16:59:23 +0800 (CST)
From: Chen-Yu Tsai <wens@kernel.org>
To: linux-wireless@vger.kernel.org,
	Brian Norris <briannorris@chromium.org>
Cc: Chen-Yu Tsai <wens@kernel.org>,
	wireless-regdb@lists.infradead.org
Subject: Re: [PATCH] wireless-regdb: Makefile: Reproducible signatures
Date: Tue,  5 Dec 2023 16:59:13 +0800
Message-Id: <170176669164.1176895.2576180821287643746.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20231116221828.301564-1-briannorris@chromium.org>
References: <20231116221828.301564-1-briannorris@chromium.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit


On Thu, 16 Nov 2023 14:18:16 -0800, Brian Norris wrote:
> Per openssl-mime(1):
> 
>        -noattr
> 	   Normally when a message is signed a set of attributes are
> 	   included which include the signing time and supported
> 	   symmetric algorithms. With this option they are not included.
> 
> [...]

Applied, thanks!

[1/1] wireless-regdb: Makefile: Reproducible signatures
      commit: 9e0aee64cd2347b45d6d29a65105c2926c0b8dbc

Best regards,
-- 
Chen-Yu Tsai <wens@kernel.org>
